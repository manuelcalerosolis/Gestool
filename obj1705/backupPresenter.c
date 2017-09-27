/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\tablet\presenter\backupPresenter.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( BACKUPPRESENTER );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( DOCUMENTSSALES );
HB_FUNC_STATIC( BACKUPPRESENTER_NEW );
HB_FUNC_STATIC( BACKUPPRESENTER_RUNNAVIGATOR );
HB_FUNC_STATIC( BACKUPPRESENTER_PLAY );
HB_FUNC_STATIC( BACKUPPRESENTER_RUNBACKUP );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( BACKUPVIEW );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( TBACKUP );
HB_FUNC_EXTERN( UFIELDEMPRESA );
HB_FUNC_EXTERN( APOLOMSGSTOP );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_BACKUPPRESENTER )
{ "BACKUPPRESENTER", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( BACKUPPRESENTER )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "DOCUMENTSSALES", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOCUMENTSSALES )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BACKUPPRESENTER_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( BACKUPPRESENTER_NEW )}, NULL },
{ "BACKUPPRESENTER_RUNNAVIGATOR", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( BACKUPPRESENTER_RUNNAVIGATOR )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BACKUPPRESENTER_PLAY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( BACKUPPRESENTER_PLAY )}, NULL },
{ "BACKUPPRESENTER_RUNBACKUP", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( BACKUPPRESENTER_RUNBACKUP )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OBACKUPVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BACKUPVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( BACKUPVIEW )}, NULL },
{ "SETTITLEDOCUMENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBACKUPVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "RESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONPRERUNNAVIGATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RUNNAVIGATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBACKUP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBACKUP )}, NULL },
{ "OPENFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_AEMP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "UFIELDEMPRESA", {HB_FS_PUBLIC}, {HB_FUNCNAME( UFIELDEMPRESA )}, NULL },
{ "_LDIR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LINTERNET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CDIR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CGETFOLDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CFILE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OPROGRESO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMETER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OPROGRESOTARGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMETERTARGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ZIPFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APOLOMSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOMSGSTOP )}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_BACKUPPRESENTER, ".\\Prg\\tablet\\presenter\\backupPresenter.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_BACKUPPRESENTER
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_BACKUPPRESENTER )
   #include "hbiniseg.h"
#endif

HB_FUNC( BACKUPPRESENTER )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,43,0,36,4,0,103,2,0,100,8,
		29,83,1,176,1,0,104,2,0,12,1,29,72,1,
		166,10,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,16,66,97,99,107,117,112,80,114,101,115,101,
		110,116,101,114,0,108,4,4,1,0,108,0,112,3,
		80,2,36,6,0,48,5,0,95,2,100,100,95,1,
		121,72,121,72,121,72,106,12,111,66,97,99,107,117,
		112,86,105,101,119,0,4,1,0,9,112,5,73,36,
		8,0,48,6,0,95,2,106,4,78,101,119,0,108,
		7,95,1,121,72,121,72,121,72,112,3,73,36,10,
		0,48,6,0,95,2,106,13,114,117,110,78,97,118,
		105,103,97,116,111,114,0,108,8,95,1,121,72,121,
		72,121,72,112,3,73,36,12,0,48,9,0,95,2,
		106,18,111,110,80,114,101,82,117,110,78,97,118,105,
		103,97,116,111,114,0,89,9,0,1,0,0,0,120,
		6,95,1,121,72,121,72,121,72,112,3,73,36,14,
		0,48,6,0,95,2,106,5,112,108,97,121,0,108,
		10,95,1,121,72,121,72,121,72,112,3,73,36,16,
		0,48,6,0,95,2,106,10,114,117,110,66,97,99,
		107,117,112,0,108,11,95,1,121,72,121,72,121,72,
		112,3,73,36,18,0,48,12,0,95,2,112,0,73,
		167,14,0,0,176,13,0,104,2,0,95,2,20,2,
		168,48,14,0,95,2,112,0,80,3,176,15,0,95,
		3,106,10,73,110,105,116,67,108,97,115,115,0,12,
		2,28,12,48,16,0,95,3,164,146,1,0,73,95,
		3,110,7,48,14,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( BACKUPPRESENTER_NEW )
{
	static const HB_BYTE pcode[] =
	{
		36,24,0,48,17,0,102,48,2,0,176,18,0,12,
		0,102,112,1,112,1,73,36,25,0,48,19,0,48,
		20,0,102,112,0,106,19,67,111,112,105,97,32,100,
		101,32,115,101,103,117,114,105,100,97,100,0,112,1,
		73,36,27,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( BACKUPPRESENTER_RUNNAVIGATOR )
{
	static const HB_BYTE pcode[] =
	{
		36,33,0,176,21,0,48,20,0,102,112,0,12,1,
		31,17,36,34,0,48,22,0,48,20,0,102,112,0,
		112,0,73,36,37,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( BACKUPPRESENTER_PLAY )
{
	static const HB_BYTE pcode[] =
	{
		36,43,0,48,23,0,102,112,0,28,12,36,44,0,
		48,24,0,102,112,0,73,36,47,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( BACKUPPRESENTER_RUNBACKUP )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,55,0,48,12,0,176,25,0,12,0,
		112,0,80,1,36,57,0,176,21,0,95,1,12,1,
		32,248,0,36,59,0,48,26,0,95,1,112,0,29,
		224,0,36,61,0,48,27,0,95,1,120,176,28,0,
		106,7,67,111,100,69,109,112,0,12,1,176,28,0,
		106,8,99,78,111,109,98,114,101,0,12,1,4,3,
		0,4,1,0,112,1,73,36,62,0,48,29,0,95,
		1,120,112,1,73,36,63,0,48,30,0,95,1,9,
		112,1,73,36,64,0,48,31,0,95,1,48,32,0,
		48,20,0,102,112,0,112,0,112,1,73,36,65,0,
		48,33,0,95,1,106,19,67,58,92,73,110,102,111,
		109,101,67,111,112,105,97,46,84,120,116,0,112,1,
		73,36,66,0,48,34,0,95,1,48,35,0,48,20,
		0,102,112,0,112,0,112,1,73,36,67,0,48,36,
		0,95,1,48,37,0,48,20,0,102,112,0,112,0,
		112,1,73,36,69,0,48,38,0,95,1,112,0,28,
		42,36,70,0,176,39,0,106,30,80,114,111,99,101,
		115,111,32,102,105,110,97,108,105,122,97,100,111,32,
		99,111,110,32,233,120,105,116,111,46,0,20,1,36,
		75,0,48,40,0,95,1,112,0,73,36,79,0,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,43,0,2,0,116,43,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

