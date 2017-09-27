/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\mail\TSendMailOutlook.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TSENDMAILOUTLOOK );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_NEW );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_BUILD );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_SENDMAIL );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETRECIPIENTS );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETRECIPIENTSCC );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETRECIPIENTSCCO );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETATTACHMENT );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETMESSAGE );
HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETSUBJECT );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( ERRORMESSAGE );
HB_FUNC_EXTERN( HB_ATOKENS );
HB_FUNC_EXTERN( FILE );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC_EXTERN( WIN_OLECREATEOBJECT );
HB_FUNC_EXTERN( WIN_OLEERRORTEXT );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TSENDMAILOUTLOOK )
{ "TSENDMAILOUTLOOK", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSENDMAILOUTLOOK_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_NEW )}, NULL },
{ "TSENDMAILOUTLOOK_BUILD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_BUILD )}, NULL },
{ "TSENDMAILOUTLOOK_SENDMAIL", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_SENDMAIL )}, NULL },
{ "TSENDMAILOUTLOOK_SETRECIPIENTS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_SETRECIPIENTS )}, NULL },
{ "TSENDMAILOUTLOOK_SETRECIPIENTSCC", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_SETRECIPIENTSCC )}, NULL },
{ "TSENDMAILOUTLOOK_SETRECIPIENTSCCO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_SETRECIPIENTSCCO )}, NULL },
{ "TSENDMAILOUTLOOK_SETATTACHMENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_SETATTACHMENT )}, NULL },
{ "TSENDMAILOUTLOOK_SETMESSAGE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_SETMESSAGE )}, NULL },
{ "TSENDMAILOUTLOOK_SETSUBJECT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDMAILOUTLOOK_SETSUBJECT )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "MAILSERVER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "CREATEITEM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETRECIPIENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETATTACHMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETRECIPIENTSCC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETRECIPIENTSCCO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETMESSAGE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETSUBJECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "ERRORMESSAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORMESSAGE )}, NULL },
{ "GETFROMHASH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_ATOKENS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ATOKENS )}, NULL },
{ "ADD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECIPIENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FILE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FILE )}, NULL },
{ "RTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( RTRIM )}, NULL },
{ "ATTACHMENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_TYPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BODYFORMAT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_HTMLBODY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSUBJECTFROMHASH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_SUBJECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_MAILSERVER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "WIN_OLECREATEOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( WIN_OLECREATEOBJECT )}, NULL },
{ "WIN_OLEERRORTEXT", {HB_FS_PUBLIC}, {HB_FUNCNAME( WIN_OLEERRORTEXT )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TSENDMAILOUTLOOK, ".\\Prg\\mail\\TSendMailOutlook.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TSENDMAILOUTLOOK
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TSENDMAILOUTLOOK )
   #include "hbiniseg.h"
#endif

HB_FUNC( TSENDMAILOUTLOOK )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,55,0,36,6,0,103,2,0,100,8,
		29,255,1,176,1,0,104,2,0,12,1,29,244,1,
		166,182,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,17,84,83,101,110,100,77,97,105,108,79,117,
		116,108,111,111,107,0,108,4,4,1,0,108,0,112,
		3,80,2,36,8,0,48,5,0,95,2,100,100,95,
		1,121,72,121,72,121,72,106,8,111,83,101,110,100,
		101,114,0,4,1,0,9,112,5,73,36,10,0,48,
		5,0,95,2,100,100,95,1,121,72,121,72,121,72,
		106,11,109,97,105,108,83,101,114,118,101,114,0,4,
		1,0,9,112,5,73,36,12,0,48,6,0,95,2,
		106,4,78,101,119,0,108,7,95,1,121,72,121,72,
		121,72,112,3,73,36,16,0,48,6,0,95,2,106,
		6,98,117,105,108,100,0,108,8,95,1,121,72,121,
		72,121,72,112,3,73,36,20,0,48,6,0,95,2,
		106,9,115,101,110,100,77,97,105,108,0,108,9,95,
		1,121,72,121,72,121,72,112,3,73,36,22,0,48,
		6,0,95,2,106,14,115,101,116,82,101,99,105,112,
		105,101,110,116,115,0,108,10,95,1,121,72,121,72,
		121,72,112,3,73,36,23,0,48,6,0,95,2,106,
		16,115,101,116,82,101,99,105,112,105,101,110,116,115,
		67,67,0,108,11,95,1,121,72,121,72,121,72,112,
		3,73,36,24,0,48,6,0,95,2,106,17,115,101,
		116,82,101,99,105,112,105,101,110,116,115,67,67,79,
		0,108,12,95,1,121,72,121,72,121,72,112,3,73,
		36,25,0,48,6,0,95,2,106,14,115,101,116,65,
		116,116,97,99,104,109,101,110,116,0,108,13,95,1,
		121,72,121,72,121,72,112,3,73,36,26,0,48,6,
		0,95,2,106,11,115,101,116,77,101,115,115,97,103,
		101,0,108,14,95,1,121,72,121,72,121,72,112,3,
		73,36,27,0,48,6,0,95,2,106,11,115,101,116,
		83,117,98,106,101,99,116,0,108,15,95,1,121,72,
		121,72,121,72,112,3,73,36,29,0,48,16,0,95,
		2,112,0,73,167,14,0,0,176,17,0,104,2,0,
		95,2,20,2,168,48,18,0,95,2,112,0,80,3,
		176,19,0,95,3,106,10,73,110,105,116,67,108,97,
		115,115,0,12,2,28,12,48,20,0,95,3,164,146,
		1,0,73,95,3,110,7,48,18,0,103,2,0,112,
		0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,35,0,48,21,0,102,95,1,112,1,
		73,36,37,0,48,22,0,102,112,0,73,36,39,0,
		102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_SENDMAIL )
{
	static const HB_BYTE pcode[] =
	{
		13,4,1,36,48,0,120,80,5,36,50,0,176,23,
		0,48,24,0,102,112,0,12,1,28,8,36,51,0,
		9,110,7,36,54,0,176,25,0,89,15,0,1,0,
		0,0,176,26,0,95,1,12,1,6,12,1,80,4,
		36,55,0,113,120,0,0,36,57,0,48,27,0,48,
		24,0,102,112,0,121,112,1,80,2,36,59,0,48,
		28,0,102,95,2,95,1,112,2,73,36,61,0,48,
		29,0,102,95,2,95,1,112,2,73,36,63,0,48,
		30,0,102,95,2,95,1,112,2,73,36,65,0,48,
		31,0,102,95,2,95,1,112,2,73,36,67,0,48,
		32,0,102,95,2,95,1,112,2,73,36,69,0,48,
		33,0,102,95,2,95,1,112,2,73,36,71,0,48,
		34,0,95,2,112,0,73,114,85,0,0,36,73,0,
		115,80,3,36,75,0,9,80,5,36,77,0,176,35,
		0,106,51,69,114,114,111,114,32,97,108,32,101,110,
		118,105,97,114,32,101,108,32,111,98,106,101,116,111,
		32,100,101,32,99,111,114,114,101,111,32,101,108,101,
		99,116,114,243,110,105,99,111,46,13,10,0,176,36,
		0,95,3,12,1,72,20,1,36,81,0,176,25,0,
		95,4,20,1,36,83,0,95,5,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETRECIPIENTS )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,90,0,48,37,0,48,38,0,102,112,
		0,95,2,106,5,109,97,105,108,0,112,2,80,4,
		36,92,0,176,23,0,95,4,12,1,31,49,36,93,
		0,176,39,0,95,4,106,2,59,0,12,2,96,3,
		0,129,1,1,28,26,36,94,0,48,40,0,48,41,
		0,95,1,112,0,95,3,112,1,73,36,95,0,130,
		31,234,132,36,98,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETATTACHMENT )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,105,0,48,37,0,48,38,0,102,112,
		0,95,2,106,12,97,116,116,97,99,104,109,101,110,
		116,115,0,112,2,80,4,36,107,0,176,23,0,95,
		4,12,1,28,8,36,108,0,100,110,7,36,111,0,
		176,39,0,95,4,106,2,59,0,12,2,96,3,0,
		129,1,1,28,102,36,112,0,176,42,0,176,43,0,
		95,3,12,1,12,1,28,27,36,113,0,48,40,0,
		48,44,0,95,1,112,0,176,43,0,95,3,12,1,
		112,1,73,25,54,36,115,0,176,35,0,106,20,70,
		105,108,101,32,116,111,32,97,116,116,97,99,104,109,
		101,110,116,32,0,176,43,0,95,3,12,1,72,106,
		11,32,110,111,116,32,102,111,117,110,100,0,72,20,
		1,36,117,0,130,31,158,132,36,119,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETRECIPIENTSCC )
{
	static const HB_BYTE pcode[] =
	{
		13,3,2,36,127,0,48,37,0,48,38,0,102,112,
		0,95,2,106,7,109,97,105,108,99,99,0,112,2,
		80,5,36,129,0,176,23,0,95,5,12,1,31,63,
		36,130,0,176,39,0,95,5,106,2,59,0,12,2,
		96,3,0,129,1,1,28,40,36,131,0,48,40,0,
		48,41,0,95,1,112,0,95,3,112,1,80,4,36,
		132,0,48,45,0,95,4,92,2,112,1,73,36,133,
		0,130,31,220,132,36,136,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETRECIPIENTSCCO )
{
	static const HB_BYTE pcode[] =
	{
		13,3,2,36,144,0,48,37,0,48,38,0,102,112,
		0,95,2,106,8,109,97,105,108,99,99,111,0,112,
		2,80,5,36,146,0,176,23,0,95,5,12,1,31,
		63,36,147,0,176,39,0,95,5,106,2,59,0,12,
		2,96,3,0,129,1,1,28,40,36,148,0,48,40,
		0,48,41,0,95,1,112,0,95,3,112,1,80,4,
		36,149,0,48,45,0,95,4,92,3,112,1,73,36,
		150,0,130,31,220,132,36,153,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETMESSAGE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,159,0,48,37,0,48,38,0,102,112,
		0,95,2,106,8,109,101,115,115,97,103,101,0,112,
		2,80,3,36,161,0,176,23,0,95,3,12,1,31,
		28,36,162,0,48,46,0,95,1,92,2,112,1,73,
		36,163,0,48,47,0,95,1,95,3,112,1,73,36,
		166,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_SETSUBJECT )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,173,0,48,48,0,48,38,0,102,112,
		0,95,2,112,1,80,3,36,175,0,176,23,0,95,
		3,12,1,31,15,36,176,0,48,49,0,95,1,95,
		3,112,1,73,36,179,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDMAILOUTLOOK_BUILD )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,188,0,176,25,0,89,15,0,1,0,
		0,0,176,26,0,95,1,12,1,6,12,1,80,1,
		36,189,0,113,112,0,0,36,191,0,48,50,0,102,
		176,51,0,106,20,79,117,116,108,111,111,107,46,65,
		112,112,108,105,99,97,116,105,111,110,0,12,1,112,
		1,73,36,193,0,176,23,0,48,24,0,102,112,0,
		12,1,28,50,36,194,0,176,35,0,106,33,69,114,
		114,111,114,46,32,77,83,32,79,117,116,108,111,111,
		107,32,110,111,32,100,105,115,112,111,110,105,98,108,
		101,46,0,176,52,0,12,0,20,2,36,195,0,114,
		78,0,0,36,197,0,115,80,2,36,199,0,176,35,
		0,106,50,69,114,114,111,114,32,97,108,32,99,114,
		101,97,114,32,101,108,32,111,98,106,101,116,111,32,
		100,101,32,99,111,114,114,101,111,32,101,108,101,99,
		116,114,243,110,105,99,111,46,13,10,0,176,36,0,
		95,2,12,1,72,20,1,36,203,0,176,25,0,95,
		1,20,1,36,205,0,176,23,0,48,24,0,102,112,
		0,12,1,68,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,55,0,2,0,116,55,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

