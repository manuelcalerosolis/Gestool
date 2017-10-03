/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\SQLDatabase.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( SQLDATABASE );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( SQLDATABASE_NEW );
HB_FUNC_STATIC( SQLDATABASE_NEWEMBEDDED );
HB_FUNC_STATIC( SQLDATABASE_CONNECT );
HB_FUNC_STATIC( SQLDATABASE_CONNECTANDCREATE );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_STATIC( SQLDATABASE_EXEC );
HB_FUNC_STATIC( SQLDATABASE_EXECS );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_STATIC( SQLDATABASE_SELECTFETCH );
HB_FUNC_STATIC( SQLDATABASE_SELECTFETCHARRAYONECOLUMN );
HB_FUNC_STATIC( SQLDATABASE_SELECTVALUE );
HB_FUNC_STATIC( SQLDATABASE_ADDMODELS );
HB_FUNC_STATIC( SQLDATABASE_CHECKMODELS );
HB_FUNC_STATIC( SQLDATABASE_CHECKMODEL );
HB_FUNC_STATIC( SQLDATABASE_GETSCHEMACOLUMNS );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( FULLCURDIR );
HB_FUNC_EXTERN( LISDIR );
HB_FUNC_EXTERN( MAKEDIR );
HB_FUNC_EXTERN( GETPVPROFSTRING );
HB_FUNC_EXTERN( CINIAPLICATION );
HB_FUNC_EXTERN( THDO );
HB_FUNC_EXTERN( BREAK );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( AEVAL );
HB_FUNC_EXTERN( HB_ISARRAY );
HB_FUNC_EXTERN( ARRAY );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( HB_ENUMINDEX );
HB_FUNC_EXTERN( QUOTED );
HB_FUNC_EXTERN( AADD );
HB_FUNC_EXTERN( TIPOSIMPRESORASMODEL );
HB_FUNC_EXTERN( TIPOSNOTASMODEL );
HB_FUNC_EXTERN( ETIQUETASMODEL );
HB_FUNC_EXTERN( SITUACIONESMODEL );
HB_FUNC_EXTERN( HISTORICOSUSUARIOSMODEL );
HB_FUNC_EXTERN( RELACIONESETIQUETASMODEL );
HB_FUNC_EXTERN( TIPOSVENTASMODEL );
HB_FUNC_EXTERN( CONFIGURACIONEMPRESASMODEL );
HB_FUNC_EXTERN( PROPIEDADESMODEL );
HB_FUNC_EXTERN( PROPIEDADESLINEASMODEL );
HB_FUNC_EXTERN( SQLMOVIMIENTOSALMACENMODEL );
HB_FUNC_EXTERN( SQLMOVIMIENTOSALMACENLINEASMODEL );
HB_FUNC( GETSQLDATABASE );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_SQLDATABASE )
{ "SQLDATABASE", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLDATABASE_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_NEW )}, NULL },
{ "SQLDATABASE_NEWEMBEDDED", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_NEWEMBEDDED )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OCONEXION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLDATABASE_CONNECT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_CONNECT )}, NULL },
{ "SQLDATABASE_CONNECTANDCREATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_CONNECTANDCREATE )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "DISCONNECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLDATABASE_EXEC", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_EXEC )}, NULL },
{ "SQLDATABASE_EXECS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_EXECS )}, NULL },
{ "QUERY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "PREPARE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLDATABASE_SELECTFETCH", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_SELECTFETCH )}, NULL },
{ "SELECTFETCH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLDATABASE_SELECTFETCHARRAYONECOLUMN", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_SELECTFETCHARRAYONECOLUMN )}, NULL },
{ "SQLDATABASE_SELECTVALUE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_SELECTVALUE )}, NULL },
{ "LASTINSERTID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BEGINTRANSACTION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "COMMIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ROLLBACK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDVIRTUAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORINFO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLDATABASE_ADDMODELS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_ADDMODELS )}, NULL },
{ "SQLDATABASE_CHECKMODELS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_CHECKMODELS )}, NULL },
{ "SQLDATABASE_CHECKMODEL", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_CHECKMODEL )}, NULL },
{ "SQLDATABASE_GETSCHEMACOLUMNS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLDATABASE_GETSCHEMACOLUMNS )}, NULL },
{ "CDATABASEMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CIPMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CUSERMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPASSWORDMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CPATHDATABASEMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FULLCURDIR", {HB_FS_PUBLIC}, {HB_FUNCNAME( FULLCURDIR )}, NULL },
{ "LISDIR", {HB_FS_PUBLIC}, {HB_FUNCNAME( LISDIR )}, NULL },
{ "CPATHDATABASEMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MAKEDIR", {HB_FS_PUBLIC}, {HB_FUNCNAME( MAKEDIR )}, NULL },
{ "_CDATABASEMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETPVPROFSTRING", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETPVPROFSTRING )}, NULL },
{ "CINIAPLICATION", {HB_FS_PUBLIC}, {HB_FUNCNAME( CINIAPLICATION )}, NULL },
{ "_CIPMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CUSERMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CPASSWORDMYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCONEXION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "THDO", {HB_FS_PUBLIC}, {HB_FUNCNAME( THDO )}, NULL },
{ "SETATTRIBUTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( BREAK )}, NULL },
{ "CONNECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EXEC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "AEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( AEVAL )}, NULL },
{ "FETCHALL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FREE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_ISARRAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ISARRAY )}, NULL },
{ "FETCHDIRECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECTFETCHARRAY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ARRAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( ARRAY )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "HB_ENUMINDEX", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ENUMINDEX )}, NULL },
{ "AMODELS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHECKMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSCHEMACOLUMNS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETCREATETABLESENTENCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EXECS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETALTERTABLESENTENCES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "QUOTED", {HB_FS_PUBLIC}, {HB_FUNCNAME( QUOTED )}, NULL },
{ "CTABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "TIPOSIMPRESORASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPOSIMPRESORASMODEL )}, NULL },
{ "TIPOSNOTASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPOSNOTASMODEL )}, NULL },
{ "ETIQUETASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ETIQUETASMODEL )}, NULL },
{ "SITUACIONESMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( SITUACIONESMODEL )}, NULL },
{ "HISTORICOSUSUARIOSMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HISTORICOSUSUARIOSMODEL )}, NULL },
{ "RELACIONESETIQUETASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( RELACIONESETIQUETASMODEL )}, NULL },
{ "TIPOSVENTASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPOSVENTASMODEL )}, NULL },
{ "CONFIGURACIONEMPRESASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( CONFIGURACIONEMPRESASMODEL )}, NULL },
{ "PROPIEDADESMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( PROPIEDADESMODEL )}, NULL },
{ "PROPIEDADESLINEASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( PROPIEDADESLINEASMODEL )}, NULL },
{ "SQLMOVIMIENTOSALMACENMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLMOVIMIENTOSALMACENMODEL )}, NULL },
{ "SQLMOVIMIENTOSALMACENLINEASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLMOVIMIENTOSALMACENLINEASMODEL )}, NULL },
{ "GETSQLDATABASE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( GETSQLDATABASE )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00003)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_SQLDATABASE, ".\\.\\Prg\\SQLDatabase.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_SQLDATABASE
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_SQLDATABASE )
   #include "hbiniseg.h"
#endif

HB_FUNC( SQLDATABASE )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,96,0,36,10,0,103,3,0,100,8,
		29,191,7,176,1,0,104,3,0,12,1,29,180,7,
		166,118,7,0,122,80,1,48,2,0,176,3,0,12,
		0,106,12,83,81,76,68,97,116,97,98,97,115,101,
		0,108,4,4,1,0,108,0,112,3,80,2,36,12,
		0,48,5,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,10,111,67,111,110,101,120,105,111,110,0,
		4,1,0,9,112,5,73,36,14,0,48,5,0,95,
		2,100,100,95,1,121,72,121,72,121,72,106,19,99,
		80,97,116,104,68,97,116,97,98,97,115,101,77,121,
		83,81,76,0,4,1,0,9,112,5,73,36,16,0,
		48,5,0,95,2,100,100,95,1,121,72,121,72,121,
		72,106,15,99,68,97,116,97,98,97,115,101,77,121,
		83,81,76,0,4,1,0,9,112,5,73,36,18,0,
		48,5,0,95,2,100,100,95,1,121,72,121,72,121,
		72,106,9,99,73,112,77,121,83,81,76,0,4,1,
		0,9,112,5,73,36,19,0,48,5,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,11,99,85,115,
		101,114,77,121,83,81,76,0,4,1,0,9,112,5,
		73,36,20,0,48,5,0,95,2,100,100,95,1,121,
		72,121,72,121,72,106,15,99,80,97,115,115,119,111,
		114,100,77,121,83,81,76,0,4,1,0,9,112,5,
		73,36,22,0,48,5,0,95,2,100,4,0,0,95,
		1,121,72,121,72,121,72,106,8,97,77,111,100,101,
		108,115,0,4,1,0,9,112,5,73,36,24,0,48,
		6,0,95,2,106,4,78,101,119,0,108,7,95,1,
		92,8,72,121,72,121,72,112,3,73,36,25,0,48,
		6,0,95,2,106,12,78,101,119,69,109,98,101,100,
		100,101,100,0,108,8,95,1,92,8,72,121,72,121,
		72,112,3,73,36,27,0,48,9,0,95,2,106,9,
		67,111,110,101,120,105,111,110,0,89,15,0,1,0,
		0,0,48,10,0,95,1,112,0,6,95,1,121,72,
		121,72,121,72,112,3,73,36,28,0,48,6,0,95,
		2,106,8,67,111,110,110,101,99,116,0,108,11,95,
		1,121,72,121,72,121,72,112,3,73,36,29,0,48,
		6,0,95,2,106,17,67,111,110,110,101,99,116,65,
		110,100,67,114,101,97,116,101,0,108,12,95,1,121,
		72,121,72,121,72,112,3,73,36,30,0,48,9,0,
		95,2,106,11,68,105,115,99,111,110,110,101,99,116,
		0,89,37,0,1,0,0,0,176,13,0,48,10,0,
		95,1,112,0,12,1,31,16,48,14,0,48,10,0,
		95,1,112,0,112,0,25,3,100,6,95,1,121,72,
		121,72,121,72,112,3,73,36,32,0,48,6,0,95,
		2,106,5,69,120,101,99,0,108,15,95,1,121,72,
		121,72,121,72,112,3,73,36,33,0,48,6,0,95,
		2,106,6,69,120,101,99,115,0,108,16,95,1,121,
		72,121,72,121,72,112,3,73,36,34,0,48,9,0,
		95,2,106,6,81,117,101,114,121,0,89,74,0,2,
		0,0,0,176,13,0,48,10,0,95,1,112,0,12,
		1,31,18,48,17,0,48,10,0,95,1,112,0,95,
		2,112,1,25,38,176,18,0,106,29,78,111,32,104,
		97,32,99,111,110,101,120,105,111,110,101,115,32,100,
		105,115,112,111,110,105,98,108,101,115,0,12,1,6,
		95,1,121,72,121,72,121,72,112,3,73,36,35,0,
		48,9,0,95,2,106,8,80,114,101,112,97,114,101,
		0,89,74,0,2,0,0,0,176,13,0,48,10,0,
		95,1,112,0,12,1,31,18,48,19,0,48,10,0,
		95,1,112,0,95,2,112,1,25,38,176,18,0,106,
		29,78,111,32,104,97,32,99,111,110,101,120,105,111,
		110,101,115,32,100,105,115,112,111,110,105,98,108,101,
		115,0,12,1,6,95,1,121,72,121,72,121,72,112,
		3,73,36,37,0,48,6,0,95,2,106,12,115,101,
		108,101,99,116,70,101,116,99,104,0,108,20,95,1,
		121,72,121,72,121,72,112,3,73,36,38,0,48,9,
		0,95,2,106,16,115,101,108,101,99,116,70,101,116,
		99,104,72,97,115,104,0,89,19,0,2,0,0,0,
		48,21,0,95,1,95,2,92,2,112,2,6,95,1,
		121,72,121,72,121,72,112,3,73,36,39,0,48,9,
		0,95,2,106,17,115,101,108,101,99,116,70,101,116,
		99,104,65,114,114,97,121,0,89,18,0,2,0,0,
		0,48,21,0,95,1,95,2,122,112,2,6,95,1,
		121,72,121,72,121,72,112,3,73,36,40,0,48,6,
		0,95,2,106,26,115,101,108,101,99,116,70,101,116,
		99,104,65,114,114,97,121,79,110,101,67,111,108,117,
		109,110,0,108,22,95,1,121,72,121,72,121,72,112,
		3,73,36,42,0,48,6,0,95,2,106,12,115,101,
		108,101,99,116,86,97,108,117,101,0,108,23,95,1,
		121,72,121,72,121,72,112,3,73,36,44,0,48,9,
		0,95,2,106,13,108,97,115,116,73,110,115,101,114,
		116,73,100,0,89,72,0,1,0,0,0,176,13,0,
		48,10,0,95,1,112,0,12,1,31,16,48,24,0,
		48,10,0,95,1,112,0,112,0,25,38,176,18,0,
		106,29,78,111,32,104,97,32,99,111,110,101,120,105,
		111,110,101,115,32,100,105,115,112,111,110,105,98,108,
		101,115,0,12,1,6,95,1,121,72,121,72,121,72,
		112,3,73,36,46,0,48,9,0,95,2,106,17,98,
		101,103,105,110,84,114,97,110,115,97,99,116,105,111,
		110,0,89,72,0,1,0,0,0,176,13,0,48,10,
		0,95,1,112,0,12,1,31,16,48,25,0,48,10,
		0,95,1,112,0,112,0,25,38,176,18,0,106,29,
		78,111,32,104,97,32,99,111,110,101,120,105,111,110,
		101,115,32,100,105,115,112,111,110,105,98,108,101,115,
		0,12,1,6,95,1,121,72,121,72,121,72,112,3,
		73,36,47,0,48,9,0,95,2,106,7,99,111,109,
		109,105,116,0,89,72,0,1,0,0,0,176,13,0,
		48,10,0,95,1,112,0,12,1,31,16,48,26,0,
		48,10,0,95,1,112,0,112,0,25,38,176,18,0,
		106,29,78,111,32,104,97,32,99,111,110,101,120,105,
		111,110,101,115,32,100,105,115,112,111,110,105,98,108,
		101,115,0,12,1,6,95,1,121,72,121,72,121,72,
		112,3,73,36,48,0,48,9,0,95,2,106,9,114,
		111,108,108,98,97,99,107,0,89,72,0,1,0,0,
		0,176,13,0,48,10,0,95,1,112,0,12,1,31,
		16,48,27,0,48,10,0,95,1,112,0,112,0,25,
		38,176,18,0,106,29,78,111,32,104,97,32,99,111,
		110,101,120,105,111,110,101,115,32,100,105,115,112,111,
		110,105,98,108,101,115,0,12,1,6,95,1,121,72,
		121,72,121,72,112,3,73,36,50,0,48,28,0,95,
		2,106,16,115,116,97,114,116,70,111,114,101,105,103,
		110,75,101,121,0,112,1,73,36,51,0,48,28,0,
		95,2,106,14,101,110,100,70,111,114,101,105,103,110,
		75,101,121,0,112,1,73,36,53,0,48,9,0,95,
		2,106,10,101,114,114,111,114,73,110,102,111,0,89,
		37,0,1,0,0,0,176,13,0,48,10,0,95,1,
		112,0,12,1,31,16,48,29,0,48,10,0,95,1,
		112,0,112,0,25,3,100,6,95,1,121,72,121,72,
		121,72,112,3,73,36,55,0,48,6,0,95,2,106,
		10,97,100,100,77,111,100,101,108,115,0,108,30,95,
		1,121,72,121,72,121,72,112,3,73,36,57,0,48,
		6,0,95,2,106,12,99,104,101,99,107,77,111,100,
		101,108,115,0,108,31,95,1,121,72,121,72,121,72,
		112,3,73,36,58,0,48,6,0,95,2,106,11,99,
		104,101,99,107,77,111,100,101,108,0,108,32,95,1,
		121,72,121,72,121,72,112,3,73,36,59,0,48,6,
		0,95,2,106,17,103,101,116,83,99,104,101,109,97,
		67,111,108,117,109,110,115,0,108,33,95,1,121,72,
		121,72,121,72,112,3,73,36,64,0,48,9,0,95,
		2,106,16,115,97,121,67,111,110,101,120,105,111,110,
		73,110,102,111,0,89,119,0,1,0,0,0,106,12,
		68,97,116,97,98,97,115,101,32,58,32,0,48,34,
		0,95,1,112,0,72,106,2,13,0,72,106,2,10,
		0,72,106,6,73,80,32,58,32,0,72,48,35,0,
		95,1,112,0,72,106,2,13,0,72,106,2,10,0,
		72,106,8,85,115,101,114,32,58,32,0,72,48,36,
		0,95,1,112,0,72,106,2,13,0,72,106,2,10,
		0,72,106,12,80,97,115,115,119,111,114,100,32,58,
		32,0,72,48,37,0,95,1,112,0,72,6,95,1,
		121,72,121,72,121,72,112,3,73,36,66,0,48,38,
		0,95,2,112,0,73,167,14,0,0,176,39,0,104,
		3,0,95,2,20,2,168,48,40,0,95,2,112,0,
		80,3,176,41,0,95,3,106,10,73,110,105,116,67,
		108,97,115,115,0,12,2,28,12,48,42,0,95,3,
		164,146,1,0,73,95,3,110,7,48,40,0,103,3,
		0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_NEW )
{
	static const HB_BYTE pcode[] =
	{
		36,72,0,48,43,0,102,176,44,0,12,0,106,10,
		68,97,116,97,98,97,115,101,92,0,72,112,1,73,
		36,74,0,176,45,0,48,46,0,102,112,0,12,1,
		31,16,36,75,0,176,47,0,48,46,0,102,112,0,
		20,1,36,78,0,48,48,0,102,176,49,0,106,6,
		77,121,83,81,76,0,106,9,68,97,116,97,98,97,
		115,101,0,106,8,103,101,115,116,111,111,108,0,176,
		50,0,12,0,12,4,112,1,73,36,79,0,48,51,
		0,102,176,49,0,106,6,77,121,83,81,76,0,106,
		3,73,112,0,106,10,49,50,55,46,48,46,48,46,
		49,0,176,50,0,12,0,12,4,112,1,73,36,80,
		0,48,52,0,102,176,49,0,106,6,77,121,83,81,
		76,0,106,5,85,115,101,114,0,106,5,114,111,111,
		116,0,176,50,0,12,0,12,4,112,1,73,36,81,
		0,48,53,0,102,176,49,0,106,6,77,121,83,81,
		76,0,106,9,80,97,115,115,119,111,114,100,0,106,
		1,0,176,50,0,12,0,12,4,112,1,73,36,83,
		0,48,54,0,102,48,2,0,176,55,0,12,0,106,
		6,109,121,115,113,108,0,112,1,112,1,73,36,85,
		0,48,56,0,48,10,0,102,112,0,92,5,120,112,
		2,73,36,87,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_NEWEMBEDDED )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,93,0,106,8,71,69,83,84,79,79,
		76,0,106,28,45,45,100,101,102,97,117,108,116,115,
		45,102,105,108,101,61,46,47,109,121,115,113,108,46,
		99,110,102,0,4,2,0,80,1,36,95,0,106,7,
		115,101,114,118,101,114,0,106,9,101,109,98,101,100,
		100,101,100,0,4,2,0,80,2,36,99,0,48,56,
		0,48,10,0,102,112,0,92,5,120,112,2,73,36,
		101,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_CONNECT )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,107,0,120,80,1,36,109,0,113,84,
		0,0,89,15,0,1,0,0,0,176,57,0,95,1,
		12,1,6,178,36,111,0,176,13,0,48,10,0,102,
		112,0,12,1,31,42,36,112,0,48,58,0,48,10,
		0,102,112,0,48,34,0,102,112,0,48,35,0,102,
		112,0,48,36,0,102,112,0,48,37,0,102,112,0,
		112,4,80,1,36,113,0,73,114,15,0,0,36,115,
		0,115,73,36,117,0,9,80,1,36,121,0,95,1,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_CONNECTANDCREATE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,127,0,120,80,1,36,129,0,113,181,
		0,0,89,15,0,1,0,0,0,176,57,0,95,1,
		12,1,6,178,36,131,0,176,13,0,48,10,0,102,
		112,0,12,1,32,139,0,36,133,0,48,58,0,48,
		10,0,102,112,0,100,48,35,0,102,112,0,48,36,
		0,102,112,0,48,37,0,102,112,0,112,4,80,1,
		36,135,0,95,1,28,96,36,136,0,48,59,0,48,
		10,0,102,112,0,106,31,67,82,69,65,84,69,32,
		68,65,84,65,66,65,83,69,32,73,70,32,78,79,
		84,32,69,88,73,83,84,83,32,0,48,34,0,102,
		112,0,72,106,2,59,0,72,112,1,73,36,137,0,
		48,59,0,48,10,0,102,112,0,106,5,85,83,69,
		32,0,48,34,0,102,112,0,72,106,2,59,0,72,
		112,1,73,36,140,0,73,114,15,0,0,36,142,0,
		115,73,36,144,0,9,80,1,36,148,0,95,1,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_EXEC )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,155,0,120,80,2,36,158,0,176,13,
		0,48,10,0,102,112,0,12,1,28,48,36,159,0,
		176,18,0,106,30,78,111,32,104,97,121,32,99,111,
		110,101,120,105,111,110,101,115,32,100,105,115,112,111,
		110,105,98,108,101,115,0,20,1,36,160,0,9,110,
		7,36,163,0,113,42,0,0,89,15,0,1,0,0,
		0,176,57,0,95,1,12,1,6,178,36,165,0,48,
		59,0,48,10,0,102,112,0,95,1,112,1,73,73,
		114,32,0,0,36,167,0,115,80,3,36,169,0,48,
		60,0,176,61,0,12,0,95,3,112,1,73,36,171,
		0,9,80,2,36,175,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_EXECS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,179,0,102,80,2,36,181,0,176,62,
		0,95,1,89,19,0,1,0,1,0,2,0,48,59,
		0,95,255,95,1,112,1,6,20,2,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_SELECTFETCH )
{
	static const HB_BYTE pcode[] =
	{
		13,3,2,36,191,0,95,2,100,8,28,5,122,80,
		2,36,193,0,176,13,0,48,10,0,102,112,0,12,
		1,28,48,36,194,0,176,18,0,106,30,78,111,32,
		104,97,121,32,99,111,110,101,120,105,111,110,101,115,
		32,100,105,115,112,111,110,105,98,108,101,115,0,20,
		1,36,195,0,100,110,7,36,198,0,166,83,0,0,
		113,57,0,0,89,15,0,1,0,0,0,176,57,0,
		95,1,12,1,6,178,36,200,0,48,17,0,48,10,
		0,102,112,0,95,1,112,1,80,5,36,202,0,48,
		63,0,95,5,95,2,112,1,80,4,73,114,26,0,
		0,36,204,0,115,80,3,36,206,0,48,60,0,176,
		61,0,12,0,95,3,112,1,73,167,30,0,0,36,
		210,0,176,13,0,95,5,12,1,31,13,36,211,0,
		48,64,0,95,5,112,0,73,36,212,0,168,36,216,
		0,176,13,0,95,4,12,1,31,18,176,65,0,95,
		4,12,1,28,9,36,217,0,95,4,110,7,36,220,
		0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_SELECTVALUE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,230,0,176,13,0,48,10,0,102,112,
		0,12,1,28,48,36,231,0,176,18,0,106,30,78,
		111,32,104,97,121,32,99,111,110,101,120,105,111,110,
		101,115,32,100,105,115,112,111,110,105,98,108,101,115,
		0,20,1,36,232,0,9,110,7,36,235,0,166,93,
		0,0,113,67,0,0,89,15,0,1,0,0,0,176,
		57,0,95,1,12,1,6,178,36,237,0,48,17,0,
		48,10,0,102,112,0,95,1,112,1,80,4,36,239,
		0,48,66,0,95,4,112,0,73,36,241,0,48,67,
		0,95,4,122,112,1,80,3,73,114,26,0,0,36,
		243,0,115,80,2,36,245,0,48,60,0,176,61,0,
		12,0,95,2,112,1,73,167,30,0,0,36,249,0,
		176,13,0,95,4,12,1,31,13,36,250,0,48,64,
		0,95,4,112,0,73,36,251,0,168,36,255,0,95,
		3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_SELECTFETCHARRAYONECOLUMN )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,9,1,48,68,0,102,95,1,112,1,
		80,3,36,11,1,176,65,0,95,3,12,1,31,8,
		36,12,1,100,110,7,36,15,1,176,69,0,176,70,
		0,95,3,12,1,12,1,80,4,36,17,1,95,3,
		96,2,0,129,1,1,28,23,36,18,1,95,2,122,
		1,95,4,176,71,0,12,0,2,36,19,1,130,31,
		237,132,36,21,1,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_CHECKMODELS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,25,1,102,80,1,36,27,1,176,62,
		0,48,72,0,95,1,112,0,89,19,0,1,0,1,
		0,1,0,48,73,0,95,255,95,1,112,1,6,20,
		2,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_CHECKMODEL )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,33,1,48,74,0,102,95,1,112,1,
		80,2,36,35,1,176,13,0,95,2,12,1,28,21,
		36,36,1,48,59,0,102,48,75,0,95,1,112,0,
		112,1,73,25,21,36,38,1,48,76,0,102,48,77,
		0,95,1,95,2,112,1,112,1,73,36,41,1,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_GETSCHEMACOLUMNS )
{
	static const HB_BYTE pcode[] =
	{
		13,4,1,36,52,1,176,13,0,48,10,0,102,112,
		0,12,1,28,48,36,53,1,176,18,0,106,30,78,
		111,32,104,97,121,32,99,111,110,101,120,105,111,110,
		101,115,32,100,105,115,112,111,110,105,98,108,101,115,
		0,20,1,36,54,1,100,110,7,36,59,1,106,71,
		83,69,76,69,67,84,32,67,79,76,85,77,78,95,
		78,65,77,69,32,70,82,79,77,32,73,78,70,79,
		82,77,65,84,73,79,78,95,83,67,72,69,77,65,
		46,67,79,76,85,77,78,83,32,87,72,69,82,69,
		32,116,97,98,108,101,95,110,97,109,101,32,61,32,
		0,176,78,0,48,79,0,95,1,112,0,12,1,72,
		80,3,36,61,1,166,83,0,0,113,57,0,0,89,
		15,0,1,0,0,0,176,57,0,95,1,12,1,6,
		178,36,63,1,48,17,0,48,10,0,102,112,0,95,
		3,112,1,80,4,36,65,1,48,63,0,95,4,92,
		2,112,1,80,5,73,114,26,0,0,36,67,1,115,
		80,2,36,69,1,48,60,0,176,61,0,12,0,95,
		2,112,1,73,167,30,0,0,36,73,1,176,13,0,
		95,4,12,1,31,13,36,74,1,48,64,0,95,4,
		112,0,73,36,75,1,168,36,79,1,176,13,0,95,
		5,12,1,31,11,176,65,0,95,5,12,1,31,8,
		36,80,1,100,110,7,36,83,1,95,5,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLDATABASE_ADDMODELS )
{
	static const HB_BYTE pcode[] =
	{
		36,89,1,176,80,0,48,72,0,102,112,0,48,2,
		0,176,81,0,12,0,112,0,20,2,36,91,1,176,
		80,0,48,72,0,102,112,0,48,2,0,176,82,0,
		12,0,112,0,20,2,36,93,1,176,80,0,48,72,
		0,102,112,0,48,2,0,176,83,0,12,0,112,0,
		20,2,36,95,1,176,80,0,48,72,0,102,112,0,
		48,2,0,176,84,0,12,0,112,0,20,2,36,97,
		1,176,80,0,48,72,0,102,112,0,48,2,0,176,
		85,0,12,0,112,0,20,2,36,99,1,176,80,0,
		48,72,0,102,112,0,48,2,0,176,86,0,12,0,
		112,0,20,2,36,101,1,176,80,0,48,72,0,102,
		112,0,48,2,0,176,87,0,12,0,112,0,20,2,
		36,103,1,176,80,0,48,72,0,102,112,0,48,2,
		0,176,88,0,12,0,112,0,20,2,36,105,1,176,
		80,0,48,72,0,102,112,0,48,2,0,176,89,0,
		12,0,112,0,20,2,36,107,1,176,80,0,48,72,
		0,102,112,0,48,2,0,176,90,0,12,0,112,0,
		20,2,36,109,1,176,80,0,48,72,0,102,112,0,
		48,2,0,176,91,0,12,0,112,0,20,2,36,111,
		1,176,80,0,48,72,0,102,112,0,48,2,0,176,
		92,0,12,0,112,0,20,2,36,113,1,48,72,0,
		102,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( GETSQLDATABASE )
{
	static const HB_BYTE pcode[] =
	{
		116,96,0,36,119,1,176,13,0,103,2,0,12,1,
		28,18,36,120,1,48,2,0,176,0,0,12,0,112,
		0,82,2,0,36,123,1,103,2,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,96,0,3,0,116,96,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

