/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\TFTPLinux.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TFTPLINUX );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( TFTPLINUX_NEW );
HB_FUNC_STATIC( TFTPLINUX_NEWPRESTASHOPCONFIG );
HB_FUNC_STATIC( TFTPLINUX_CREATECONEXION );
HB_FUNC_STATIC( TFTPLINUX_ENDCONEXION );
HB_FUNC_EXTERN( HB_ISLOGICAL );
HB_FUNC_STATIC( TFTPLINUX_CREATEDIRECTORY );
HB_FUNC_STATIC( TFTPLINUX_CREATEDIRECTORYRECURSIVE );
HB_FUNC_STATIC( TFTPLINUX_RETURNDIRECTORY );
HB_FUNC_STATIC( TFTPLINUX_CREATEFILE );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( TURL );
HB_FUNC_EXTERN( TIPCLIENTFTP );
HB_FUNC_EXTERN( HB_EOL );
HB_FUNC_EXTERN( HB_INETERRORCODE );
HB_FUNC_EXTERN( HB_INETERRORDESC );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( SUBSTR );
HB_FUNC_EXTERN( LEN );
HB_FUNC( TFTPWINDOWS );
HB_FUNC_STATIC( TFTPWINDOWS_CREATECONEXION );
HB_FUNC_STATIC( TFTPWINDOWS_ENDCONEXION );
HB_FUNC_STATIC( TFTPWINDOWS_CREATEDIRECTORY );
HB_FUNC_STATIC( TFTPWINDOWS_RETURNDIRECTORY );
HB_FUNC_STATIC( TFTPWINDOWS_CREATEFILE );
HB_FUNC_EXTERN( TINTERNET );
HB_FUNC_EXTERN( TFTP );
HB_FUNC_EXTERN( SPACE );
HB_FUNC_EXTERN( FILE );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( TFTPFILE );
HB_FUNC_EXTERN( CNOPATH );
HB_FUNC_EXTERN( FOPEN );
HB_FUNC_EXTERN( FERROR );
HB_FUNC_EXTERN( FSEEK );
HB_FUNC_EXTERN( FREAD );
HB_FUNC_EXTERN( SYSREFRESH );
HB_FUNC_EXTERN( FCLOSE );
HB_FUNC( TFTPCURL );
HB_FUNC_STATIC( TFTPCURL_CREATECONEXION );
HB_FUNC_EXTERN( CURL_GLOBAL_CLEANUP );
HB_FUNC_STATIC( TFTPCURL_CREATEFILE );
HB_FUNC_STATIC( TFTPCURL_DOWNLOADFILE );
HB_FUNC_STATIC( TFTPCURL_LISTFILES );
HB_FUNC_STATIC( TFTPCURL_DELETEFILE );
HB_FUNC_EXTERN( CURL_GLOBAL_INIT );
HB_FUNC_EXTERN( CURL_EASY_INIT );
HB_FUNC_EXTERN( CLEFTPATH );
HB_FUNC_EXTERN( CURL_EASY_SETOPT );
HB_FUNC_EXTERN( HB_FSIZE );
HB_FUNC_EXTERN( CURL_EASY_PERFORM );
HB_FUNC_EXTERN( CURL_EASY_GETINFO );
HB_FUNC_EXTERN( CURL_EASY_RESET );
HB_FUNC_EXTERN( RIGHT );
HB_FUNC_EXTERN( CURL_EASY_DL_BUFF_GET );
HB_FUNC_EXTERN( HB_ATOKENS );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TFTPLINUX )
{ "TFTPLINUX", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TFTPLINUX_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX_NEW )}, NULL },
{ "TFTPLINUX_NEWPRESTASHOPCONFIG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX_NEWPRESTASHOPCONFIG )}, NULL },
{ "TFTPLINUX_CREATECONEXION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX_CREATECONEXION )}, NULL },
{ "TFTPLINUX_ENDCONEXION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX_ENDCONEXION )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_ISLOGICAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ISLOGICAL )}, NULL },
{ "_LPASSIVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LPASSIVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CERROR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TFTPLINUX_CREATEDIRECTORY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX_CREATEDIRECTORY )}, NULL },
{ "TFTPLINUX_CREATEDIRECTORYRECURSIVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX_CREATEDIRECTORYRECURSIVE )}, NULL },
{ "TFTPLINUX_RETURNDIRECTORY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX_RETURNDIRECTORY )}, NULL },
{ "TFTPLINUX_CREATEFILE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPLINUX_CREATEFILE )}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "GETFTPSERVER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCOMERCIOCONFIG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFTPUSER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFTPPASSWORD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFTPPASSIVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLASSNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CUSER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CPASSWORD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CSERVER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NPORT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_TCOMERCIOCONFIG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFTPPORT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "CUSER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPASSWORD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSERVER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TURL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TURL )}, NULL },
{ "_CPROTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CUSERID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NPORT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OFTP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPCLIENTFTP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPCLIENTFTP )}, NULL },
{ "_NCONNTIMEOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OFTP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BUSEPASV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NDEFAULTPORT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CERROR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SOCKETCON", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_EOL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_EOL )}, NULL },
{ "HB_INETERRORCODE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_INETERRORCODE )}, NULL },
{ "CREPLY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_INETERRORDESC", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_INETERRORDESC )}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "CLOSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MKD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CWD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEDIRECTORY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SUBSTR", {HB_FS_PUBLIC}, {HB_FUNCNAME( SUBSTR )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "UPLOADFILE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TFTPWINDOWS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPWINDOWS )}, NULL },
{ "TFTPWINDOWS_CREATECONEXION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPWINDOWS_CREATECONEXION )}, NULL },
{ "TFTPWINDOWS_ENDCONEXION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPWINDOWS_ENDCONEXION )}, NULL },
{ "TFTPWINDOWS_CREATEDIRECTORY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPWINDOWS_CREATEDIRECTORY )}, NULL },
{ "TFTPWINDOWS_RETURNDIRECTORY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPWINDOWS_RETURNDIRECTORY )}, NULL },
{ "TFTPWINDOWS_CREATEFILE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPWINDOWS_CREATEFILE )}, NULL },
{ "_OINT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TINTERNET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TINTERNET )}, NULL },
{ "TFTP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TFTP )}, NULL },
{ "OINT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HFTP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCURRENTDIRECTORY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SPACE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SPACE )}, NULL },
{ "FILE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FILE )}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "TFTPFILE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TFTPFILE )}, NULL },
{ "CNOPATH", {HB_FS_PUBLIC}, {HB_FUNCNAME( CNOPATH )}, NULL },
{ "OPENWRITE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FOPEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( FOPEN )}, NULL },
{ "FERROR", {HB_FS_PUBLIC}, {HB_FUNCNAME( FERROR )}, NULL },
{ "FSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( FSEEK )}, NULL },
{ "FREAD", {HB_FS_PUBLIC}, {HB_FUNCNAME( FREAD )}, NULL },
{ "WRITE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SYSREFRESH", {HB_FS_PUBLIC}, {HB_FUNCNAME( SYSREFRESH )}, NULL },
{ "FCLOSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FCLOSE )}, NULL },
{ "TFTPCURL", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPCURL )}, NULL },
{ "TFTPCURL_CREATECONEXION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPCURL_CREATECONEXION )}, NULL },
{ "CURL_GLOBAL_CLEANUP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURL_GLOBAL_CLEANUP )}, NULL },
{ "ADDVIRTUAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TFTPCURL_CREATEFILE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPCURL_CREATEFILE )}, NULL },
{ "TFTPCURL_DOWNLOADFILE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPCURL_DOWNLOADFILE )}, NULL },
{ "TFTPCURL_LISTFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPCURL_LISTFILES )}, NULL },
{ "TFTPCURL_DELETEFILE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TFTPCURL_DELETEFILE )}, NULL },
{ "CURL_GLOBAL_INIT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURL_GLOBAL_INIT )}, NULL },
{ "_IDCURL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CURL_EASY_INIT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURL_EASY_INIT )}, NULL },
{ "IDCURL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLEFTPATH", {HB_FS_PUBLIC}, {HB_FUNCNAME( CLEFTPATH )}, NULL },
{ "CURL_EASY_SETOPT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURL_EASY_SETOPT )}, NULL },
{ "HB_FSIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_FSIZE )}, NULL },
{ "CURL_EASY_PERFORM", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURL_EASY_PERFORM )}, NULL },
{ "CURL_EASY_GETINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURL_EASY_GETINFO )}, NULL },
{ "CURL_EASY_RESET", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURL_EASY_RESET )}, NULL },
{ "RIGHT", {HB_FS_PUBLIC}, {HB_FUNCNAME( RIGHT )}, NULL },
{ "CURL_EASY_DL_BUFF_GET", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURL_EASY_DL_BUFF_GET )}, NULL },
{ "HB_ATOKENS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ATOKENS )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00004)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TFTPLINUX, ".\\.\\Prg\\TFTPLinux.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TFTPLINUX
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TFTPLINUX )
   #include "hbiniseg.h"
#endif

HB_FUNC( TFTPLINUX )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,116,0,36,16,0,103,2,0,100,8,
		29,42,4,176,1,0,104,2,0,12,1,29,31,4,
		166,225,3,0,122,80,1,48,2,0,176,3,0,12,
		0,106,10,84,70,116,112,76,105,110,117,120,0,108,
		4,4,1,0,108,0,112,3,80,2,36,18,0,48,
		5,0,95,2,100,100,95,1,121,72,121,72,121,72,
		106,5,111,70,84,80,0,4,1,0,9,112,5,73,
		36,19,0,48,5,0,95,2,100,106,1,0,95,1,
		121,72,121,72,121,72,106,7,99,69,114,114,111,114,
		0,4,1,0,9,112,5,73,36,21,0,48,5,0,
		95,2,100,9,95,1,121,72,121,72,121,72,106,8,
		108,72,97,115,83,83,76,0,4,1,0,9,112,5,
		73,36,23,0,48,5,0,95,2,100,100,95,1,121,
		72,121,72,121,72,106,16,84,67,111,109,101,114,99,
		105,111,67,111,110,102,105,103,0,4,1,0,9,112,
		5,73,36,25,0,48,5,0,95,2,100,100,95,1,
		121,72,121,72,121,72,106,8,99,83,101,114,118,101,
		114,0,4,1,0,9,112,5,73,36,26,0,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		6,99,85,115,101,114,0,4,1,0,9,112,5,73,
		36,27,0,48,5,0,95,2,100,100,95,1,121,72,
		121,72,121,72,106,10,99,80,97,115,115,119,111,114,
		100,0,4,1,0,9,112,5,73,36,28,0,48,5,
		0,95,2,100,92,21,95,1,121,72,121,72,121,72,
		106,6,110,80,111,114,116,0,4,1,0,9,112,5,
		73,36,30,0,48,5,0,95,2,100,9,95,1,121,
		72,121,72,121,72,106,9,108,80,97,115,115,105,118,
		101,0,4,1,0,9,112,5,73,36,32,0,48,6,
		0,95,2,106,4,110,101,119,0,108,7,95,1,121,
		72,121,72,121,72,112,3,73,36,33,0,48,6,0,
		95,2,106,20,110,101,119,80,114,101,115,116,97,115,
		104,111,112,67,111,110,102,105,103,0,108,8,95,1,
		121,72,121,72,121,72,112,3,73,36,35,0,48,6,
		0,95,2,106,15,99,114,101,97,116,101,67,111,110,
		101,120,105,111,110,0,108,9,95,1,121,72,121,72,
		121,72,112,3,73,36,36,0,48,6,0,95,2,106,
		12,101,110,100,67,111,110,101,120,105,111,110,0,108,
		10,95,1,121,72,121,72,121,72,112,3,73,36,38,
		0,48,11,0,95,2,106,11,115,101,116,80,97,115,
		115,105,118,101,0,89,35,0,2,0,0,0,176,12,
		0,95,2,12,1,28,13,48,13,0,95,1,95,2,
		112,1,25,9,48,14,0,95,1,112,0,6,95,1,
		121,72,121,72,121,72,112,3,73,36,40,0,48,11,
		0,95,2,106,9,103,101,116,69,114,114,111,114,0,
		89,15,0,1,0,0,0,48,15,0,95,1,112,0,
		6,95,1,121,72,121,72,121,72,112,3,73,36,42,
		0,48,6,0,95,2,106,16,99,114,101,97,116,101,
		68,105,114,101,99,116,111,114,121,0,108,16,95,1,
		121,72,121,72,121,72,112,3,73,36,43,0,48,6,
		0,95,2,106,25,99,114,101,97,116,101,68,105,114,
		101,99,116,111,114,121,82,101,99,117,114,115,105,118,
		101,0,108,17,95,1,121,72,121,72,121,72,112,3,
		73,36,44,0,48,6,0,95,2,106,16,114,101,116,
		117,114,110,68,105,114,101,99,116,111,114,121,0,108,
		18,95,1,121,72,121,72,121,72,112,3,73,36,46,
		0,48,6,0,95,2,106,11,99,114,101,97,116,101,
		70,105,108,101,0,108,19,95,1,121,72,121,72,121,
		72,112,3,73,36,52,0,48,11,0,95,2,106,4,
		115,97,121,0,89,183,0,1,0,0,0,176,20,0,
		106,10,83,101,114,118,101,114,32,58,32,0,48,21,
		0,48,22,0,95,1,112,0,112,0,72,106,2,13,
		0,72,106,2,10,0,72,106,8,85,115,101,114,32,
		58,32,0,72,48,23,0,48,22,0,95,1,112,0,
		112,0,72,106,2,13,0,72,106,2,10,0,72,106,
		12,80,97,115,115,119,111,114,100,32,58,32,0,72,
		48,24,0,48,22,0,95,1,112,0,112,0,72,106,
		2,13,0,72,106,2,10,0,72,48,25,0,48,22,
		0,95,1,112,0,112,0,28,14,106,8,80,97,115,
		115,105,118,101,0,25,15,106,11,78,111,32,112,97,
		115,115,105,118,101,0,72,106,13,67,108,97,115,115,
		78,97,109,101,32,58,32,0,48,26,0,95,1,112,
		0,72,12,2,6,95,1,121,72,121,72,121,72,112,
		3,73,36,54,0,48,27,0,95,2,112,0,73,167,
		14,0,0,176,28,0,104,2,0,95,2,20,2,168,
		48,29,0,95,2,112,0,80,3,176,30,0,95,3,
		106,10,73,110,105,116,67,108,97,115,115,0,12,2,
		28,12,48,31,0,95,3,164,146,1,0,73,95,3,
		110,7,48,29,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPLINUX_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,4,36,60,0,95,4,100,8,28,6,92,21,
		80,4,36,62,0,48,32,0,102,95,1,112,1,73,
		36,63,0,48,33,0,102,95,2,112,1,73,36,64,
		0,48,34,0,102,95,3,112,1,73,36,65,0,48,
		35,0,102,95,4,112,1,73,36,67,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPLINUX_NEWPRESTASHOPCONFIG )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,73,0,48,36,0,102,95,1,112,1,
		73,36,75,0,48,2,0,102,48,23,0,48,22,0,
		102,112,0,112,0,48,24,0,48,22,0,102,112,0,
		112,0,48,21,0,48,22,0,102,112,0,112,0,48,
		37,0,48,22,0,102,112,0,112,0,112,4,73,36,
		77,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPLINUX_CREATECONEXION )
{
	static const HB_BYTE pcode[] =
	{
		13,3,0,36,86,0,9,80,3,36,88,0,176,38,
		0,48,21,0,48,22,0,102,112,0,112,0,12,1,
		32,46,2,36,90,0,106,7,102,116,112,58,47,47,
		0,48,39,0,102,112,0,72,106,2,58,0,72,48,
		40,0,102,112,0,72,106,2,64,0,72,48,41,0,
		102,112,0,72,80,1,36,92,0,48,2,0,176,42,
		0,12,0,95,1,112,1,80,2,36,93,0,48,43,
		0,95,2,106,4,102,116,112,0,112,1,73,36,94,
		0,48,34,0,95,2,48,41,0,102,112,0,112,1,
		73,36,95,0,48,44,0,95,2,48,39,0,102,112,
		0,112,1,73,36,96,0,48,33,0,95,2,48,40,
		0,102,112,0,112,1,73,36,97,0,48,35,0,95,
		2,48,45,0,102,112,0,112,1,73,36,99,0,48,
		46,0,102,48,2,0,176,47,0,12,0,95,2,120,
		112,2,112,1,73,36,100,0,48,48,0,48,49,0,
		102,112,0,93,32,78,112,1,73,36,101,0,48,50,
		0,48,49,0,102,112,0,48,14,0,102,112,0,112,
		1,73,36,102,0,48,51,0,48,49,0,102,112,0,
		48,45,0,102,112,0,112,1,73,36,104,0,48,52,
		0,48,49,0,102,112,0,112,0,80,3,36,105,0,
		95,3,32,48,1,36,107,0,48,53,0,102,106,33,
		67,111,117,108,100,32,110,111,116,32,99,111,110,110,
		101,99,116,32,116,111,32,70,84,80,32,115,101,114,
		118,101,114,32,0,48,41,0,95,2,112,0,72,112,
		1,73,36,108,0,176,38,0,48,54,0,48,49,0,
		102,112,0,112,0,12,1,28,59,36,109,0,48,53,
		0,102,21,48,15,0,163,0,112,0,176,55,0,12,
		0,106,27,67,111,110,110,101,99,116,105,111,110,32,
		110,111,116,32,105,110,105,116,105,97,108,105,122,101,
		100,0,72,72,112,1,73,26,159,0,36,110,0,176,
		56,0,48,54,0,48,49,0,102,112,0,112,0,12,
		1,121,8,28,65,36,111,0,48,53,0,102,21,48,
		15,0,163,0,112,0,176,55,0,12,0,106,17,83,
		101,114,118,101,114,32,114,101,115,112,111,110,115,101,
		58,0,72,106,2,32,0,72,48,57,0,48,49,0,
		102,112,0,112,0,72,72,112,1,73,25,72,36,113,
		0,48,53,0,102,21,48,15,0,163,0,112,0,176,
		55,0,12,0,106,21,69,114,114,111,114,32,105,110,
		32,99,111,110,110,101,99,116,105,111,110,58,0,72,
		106,2,32,0,72,176,58,0,48,54,0,48,49,0,
		102,112,0,112,0,12,1,72,72,112,1,73,36,116,
		0,176,59,0,48,15,0,102,112,0,20,1,36,122,
		0,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPLINUX_ENDCONEXION )
{
	static const HB_BYTE pcode[] =
	{
		36,128,0,176,38,0,48,49,0,102,112,0,12,1,
		31,17,36,129,0,48,60,0,48,49,0,102,112,0,
		112,0,73,36,132,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPLINUX_CREATEDIRECTORY )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,138,0,176,38,0,48,49,0,102,112,
		0,12,1,31,36,36,139,0,48,61,0,48,49,0,
		102,112,0,95,1,112,1,73,36,140,0,48,62,0,
		48,49,0,102,112,0,95,1,112,1,73,36,143,0,
		120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPLINUX_CREATEDIRECTORYRECURSIVE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,151,0,122,165,80,2,25,28,36,152,
		0,48,63,0,102,176,64,0,95,1,95,2,122,12,
		3,112,1,73,36,151,0,175,2,0,176,65,0,95,
		1,12,1,15,28,222,36,155,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPLINUX_CREATEFILE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,161,0,9,80,2,36,163,0,176,38,
		0,48,49,0,102,112,0,12,1,31,20,36,164,0,
		48,66,0,48,49,0,102,112,0,95,1,112,1,80,
		2,36,167,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPLINUX_RETURNDIRECTORY )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,175,0,176,38,0,48,49,0,102,112,
		0,12,1,31,47,36,176,0,122,165,80,2,25,28,
		36,177,0,48,62,0,48,49,0,102,112,0,106,3,
		46,46,0,112,1,73,36,176,0,175,2,0,176,65,
		0,95,1,12,1,15,28,222,36,181,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TFTPWINDOWS )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,116,0,36,195,0,103,3,0,100,8,
		29,85,1,176,1,0,104,3,0,12,1,29,74,1,
		166,12,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,12,84,70,84,80,87,105,110,100,111,119,115,
		0,108,0,4,1,0,108,67,112,3,80,2,36,197,
		0,48,5,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,5,111,73,110,116,0,4,1,0,9,112,
		5,73,36,199,0,48,6,0,95,2,106,15,99,114,
		101,97,116,101,67,111,110,101,120,105,111,110,0,108,
		68,95,1,121,72,121,72,121,72,112,3,73,36,200,
		0,48,6,0,95,2,106,12,101,110,100,67,111,110,
		101,120,105,111,110,0,108,69,95,1,121,72,121,72,
		121,72,112,3,73,36,202,0,48,6,0,95,2,106,
		16,99,114,101,97,116,101,68,105,114,101,99,116,111,
		114,121,0,108,70,95,1,121,72,121,72,121,72,112,
		3,73,36,203,0,48,6,0,95,2,106,16,114,101,
		116,117,114,110,68,105,114,101,99,116,111,114,121,0,
		108,71,95,1,121,72,121,72,121,72,112,3,73,36,
		205,0,48,6,0,95,2,106,11,99,114,101,97,116,
		101,70,105,108,101,0,108,72,95,1,121,72,121,72,
		121,72,112,3,73,36,207,0,48,27,0,95,2,112,
		0,73,167,14,0,0,176,28,0,104,3,0,95,2,
		20,2,168,48,29,0,95,2,112,0,80,3,176,30,
		0,95,3,106,10,73,110,105,116,67,108,97,115,115,
		0,12,2,28,12,48,31,0,95,3,164,146,1,0,
		73,95,3,110,7,48,29,0,103,3,0,112,0,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPWINDOWS_CREATECONEXION )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,213,0,9,80,1,36,215,0,176,38,
		0,48,41,0,102,112,0,12,1,31,106,36,217,0,
		48,73,0,102,48,2,0,176,74,0,12,0,112,0,
		112,1,73,36,218,0,48,46,0,102,48,2,0,176,
		75,0,12,0,48,41,0,102,112,0,48,76,0,102,
		112,0,48,39,0,102,112,0,48,40,0,102,112,0,
		48,14,0,102,112,0,112,5,112,1,73,36,220,0,
		176,38,0,48,49,0,102,112,0,12,1,31,20,36,
		221,0,48,77,0,48,49,0,102,112,0,112,0,121,
		69,80,1,36,226,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPWINDOWS_ENDCONEXION )
{
	static const HB_BYTE pcode[] =
	{
		36,232,0,176,38,0,48,76,0,102,112,0,12,1,
		31,17,36,233,0,48,78,0,48,76,0,102,112,0,
		112,0,73,36,236,0,176,38,0,48,49,0,102,112,
		0,12,1,31,17,36,237,0,48,78,0,48,49,0,
		102,112,0,112,0,73,36,240,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPWINDOWS_CREATEDIRECTORY )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,246,0,176,38,0,48,49,0,102,112,
		0,12,1,31,36,36,247,0,48,63,0,48,49,0,
		102,112,0,95,1,112,1,73,36,248,0,48,79,0,
		48,49,0,102,112,0,95,1,112,1,73,36,251,0,
		120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPWINDOWS_CREATEFILE )
{
	static const HB_BYTE pcode[] =
	{
		13,7,2,36,4,1,9,80,6,36,5,1,176,80,
		0,93,32,78,12,1,80,7,36,6,1,121,80,8,
		36,7,1,121,80,9,36,9,1,176,81,0,95,1,
		12,1,31,48,36,10,1,176,59,0,106,22,78,111,
		32,101,120,105,115,116,101,32,101,108,32,102,105,99,
		104,101,114,111,32,0,176,82,0,95,1,12,1,72,
		20,1,36,11,1,9,110,7,36,14,1,48,2,0,
		176,83,0,12,0,176,84,0,95,1,12,1,48,49,
		0,102,112,0,112,2,80,3,36,15,1,48,85,0,
		95,3,112,0,73,36,17,1,176,86,0,95,1,12,
		1,80,5,36,18,1,176,87,0,12,0,121,8,28,
		83,36,20,1,176,88,0,95,5,121,121,20,3,36,
		22,1,176,89,0,95,5,96,7,0,93,32,78,12,
		3,165,80,4,121,15,28,42,36,23,1,96,9,0,
		95,4,135,36,24,1,48,90,0,95,3,176,64,0,
		95,7,122,95,4,12,3,112,1,73,36,25,1,176,
		91,0,20,0,25,195,36,28,1,120,80,6,36,32,
		1,48,78,0,95,3,112,0,73,36,34,1,176,92,
		0,95,5,20,1,36,36,1,176,91,0,20,0,36,
		38,1,95,6,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPWINDOWS_RETURNDIRECTORY )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,46,1,122,165,80,2,25,28,36,47,
		1,48,79,0,48,49,0,102,112,0,106,3,46,46,
		0,112,1,73,36,46,1,175,2,0,176,65,0,95,
		1,12,1,15,28,222,36,50,1,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TFTPCURL )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,116,0,36,65,1,103,4,0,100,8,
		29,52,2,176,1,0,104,4,0,12,1,29,41,2,
		166,235,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,9,84,70,84,80,67,117,114,108,0,108,0,
		4,1,0,108,93,112,3,80,2,36,67,1,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		7,105,100,67,117,114,108,0,4,1,0,9,112,5,
		73,36,68,1,48,5,0,95,2,100,100,95,1,121,
		72,121,72,121,72,106,18,99,73,110,105,116,105,97,
		108,68,105,114,101,99,116,111,114,121,0,4,1,0,
		9,112,5,73,36,69,1,48,5,0,95,2,100,100,
		95,1,121,72,121,72,121,72,106,20,99,82,101,99,
		117,114,115,105,118,101,68,105,114,101,99,116,111,114,
		121,0,4,1,0,9,112,5,73,36,71,1,48,6,
		0,95,2,106,15,99,114,101,97,116,101,67,111,110,
		101,120,105,111,110,0,108,94,95,1,121,72,121,72,
		121,72,112,3,73,36,72,1,48,11,0,95,2,106,
		12,101,110,100,67,111,110,101,120,105,111,110,0,89,
		13,0,1,0,0,0,176,95,0,12,0,6,95,1,
		121,72,121,72,121,72,112,3,73,36,74,1,48,96,
		0,95,2,106,16,99,114,101,97,116,101,68,105,114,
		101,99,116,111,114,121,0,112,1,73,36,75,1,48,
		96,0,95,2,106,25,99,114,101,97,116,101,68,105,
		114,101,99,116,111,114,121,82,101,99,117,114,115,105,
		118,101,0,112,1,73,36,76,1,48,96,0,95,2,
		106,16,114,101,116,117,114,110,68,105,114,101,99,116,
		111,114,121,0,112,1,73,36,78,1,48,6,0,95,
		2,106,11,99,114,101,97,116,101,70,105,108,101,0,
		108,97,95,1,121,72,121,72,121,72,112,3,73,36,
		79,1,48,6,0,95,2,106,13,100,111,119,110,108,
		111,97,100,70,105,108,101,0,108,98,95,1,121,72,
		121,72,121,72,112,3,73,36,81,1,48,6,0,95,
		2,106,10,108,105,115,116,70,105,108,101,115,0,108,
		99,95,1,121,72,121,72,121,72,112,3,73,36,83,
		1,48,6,0,95,2,106,11,100,101,108,101,116,101,
		70,105,108,101,0,108,100,95,1,121,72,121,72,121,
		72,112,3,73,36,85,1,48,27,0,95,2,112,0,
		73,167,14,0,0,176,28,0,104,4,0,95,2,20,
		2,168,48,29,0,95,2,112,0,80,3,176,30,0,
		95,3,106,10,73,110,105,116,67,108,97,115,115,0,
		12,2,28,12,48,31,0,95,3,164,146,1,0,73,
		95,3,110,7,48,29,0,103,4,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPCURL_CREATECONEXION )
{
	static const HB_BYTE pcode[] =
	{
		36,91,1,176,101,0,20,0,36,93,1,48,102,0,
		102,176,103,0,12,0,112,1,73,36,95,1,176,38,
		0,48,104,0,102,112,0,12,1,68,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPCURL_CREATEFILE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,102,1,9,80,4,36,104,1,95,2,
		100,8,28,7,106,1,0,80,2,36,106,1,176,38,
		0,48,104,0,102,112,0,12,1,28,8,36,107,1,
		9,110,7,36,110,1,176,81,0,95,1,12,1,31,
		57,36,111,1,176,59,0,106,12,69,108,32,102,105,
		99,104,101,114,111,32,0,95,1,72,106,21,32,110,
		111,32,115,101,32,104,97,32,101,110,99,111,110,116,
		114,97,100,111,0,72,20,1,36,112,1,9,110,7,
		36,115,1,176,38,0,95,2,12,1,31,14,36,116,
		1,176,105,0,95,2,12,1,80,2,36,119,1,106,
		7,102,116,112,58,47,47,0,48,39,0,102,112,0,
		72,106,2,58,0,72,48,40,0,102,112,0,72,106,
		2,64,0,72,48,41,0,102,112,0,72,106,2,47,
		0,72,95,2,72,176,84,0,95,1,12,1,72,80,
		3,36,121,1,176,106,0,48,104,0,102,112,0,92,
		46,20,2,36,122,1,176,106,0,48,104,0,102,112,
		0,92,2,95,3,20,3,36,123,1,176,106,0,48,
		104,0,102,112,0,93,235,3,95,1,20,3,36,124,
		1,176,106,0,48,104,0,102,112,0,92,14,176,107,
		0,95,1,12,1,20,3,36,125,1,176,106,0,48,
		104,0,102,112,0,92,110,120,20,3,36,127,1,176,
		108,0,48,104,0,102,112,0,12,1,80,4,36,129,
		1,176,109,0,48,104,0,102,112,0,122,20,2,36,
		130,1,176,109,0,48,104,0,102,112,0,92,5,20,
		2,36,132,1,176,110,0,48,104,0,102,112,0,20,
		1,36,134,1,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPCURL_DOWNLOADFILE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,142,1,9,80,4,36,144,1,176,38,
		0,48,104,0,102,112,0,12,1,28,8,36,145,1,
		9,110,7,36,148,1,106,7,102,116,112,58,47,47,
		0,48,41,0,102,112,0,72,106,2,47,0,72,95,
		1,72,80,3,36,150,1,176,106,0,48,104,0,102,
		112,0,93,233,3,20,2,36,151,1,176,106,0,48,
		104,0,102,112,0,92,2,95,3,20,3,36,152,1,
		176,106,0,48,104,0,102,112,0,93,237,3,95,2,
		20,3,36,153,1,176,106,0,48,104,0,102,112,0,
		92,5,48,39,0,102,112,0,106,2,58,0,72,48,
		40,0,102,112,0,72,20,3,36,154,1,176,106,0,
		48,104,0,102,112,0,92,41,120,20,3,36,156,1,
		176,108,0,48,104,0,102,112,0,12,1,80,4,36,
		158,1,176,110,0,48,104,0,102,112,0,20,1,36,
		160,1,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPCURL_LISTFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,169,1,176,38,0,48,104,0,102,112,
		0,12,1,28,8,36,170,1,9,110,7,36,173,1,
		106,7,102,116,112,58,47,47,0,48,39,0,102,112,
		0,72,106,2,58,0,72,48,40,0,102,112,0,72,
		106,2,64,0,72,48,41,0,102,112,0,72,176,111,
		0,48,41,0,102,112,0,122,12,2,106,2,47,0,
		69,28,8,106,2,47,0,25,5,106,1,0,72,80,
		1,36,175,1,176,106,0,48,104,0,102,112,0,93,
		233,3,20,2,36,176,1,176,106,0,48,104,0,102,
		112,0,92,48,20,2,36,177,1,176,106,0,48,104,
		0,102,112,0,92,2,95,1,20,3,36,178,1,176,
		106,0,48,104,0,102,112,0,93,240,3,20,2,36,
		179,1,176,108,0,48,104,0,102,112,0,20,1,36,
		180,1,176,112,0,48,104,0,102,112,0,20,1,36,
		181,1,176,106,0,48,104,0,102,112,0,93,241,3,
		96,2,0,20,3,36,183,1,176,113,0,95,2,106,
		3,13,10,0,12,2,80,2,36,185,1,176,110,0,
		48,104,0,102,112,0,20,1,36,187,1,95,2,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TFTPCURL_DELETEFILE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,195,1,9,80,3,36,197,1,176,38,
		0,48,104,0,102,112,0,12,1,28,8,36,198,1,
		9,110,7,36,201,1,106,7,102,116,112,58,47,47,
		0,48,39,0,102,112,0,72,106,2,58,0,72,48,
		40,0,102,112,0,72,106,2,64,0,72,48,41,0,
		102,112,0,72,176,111,0,48,41,0,102,112,0,122,
		12,2,106,2,47,0,69,28,8,106,2,47,0,25,
		5,106,1,0,72,80,2,36,203,1,176,106,0,48,
		104,0,102,112,0,92,2,95,2,20,3,36,204,1,
		176,106,0,48,104,0,102,112,0,92,39,106,6,68,
		69,76,69,32,0,95,1,72,4,1,0,20,3,36,
		206,1,176,108,0,48,104,0,102,112,0,12,1,80,
		3,36,208,1,176,110,0,48,104,0,102,112,0,20,
		1,36,210,1,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,116,0,4,0,116,116,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

